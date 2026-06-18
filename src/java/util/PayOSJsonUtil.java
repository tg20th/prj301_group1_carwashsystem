package util;

import java.util.Map;
import java.util.TreeMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public final class PayOSJsonUtil {

    private PayOSJsonUtil() {
    }

    public static String escapeJson(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }

    public static String extractString(String json, String key) {
        Pattern pattern = Pattern.compile("\"" + Pattern.quote(key) + "\"\\s*:\\s*\"((?:\\\\.|[^\"\\\\])*)\"");
        Matcher matcher = pattern.matcher(json);
        if (matcher.find()) {
            return unescapeJson(matcher.group(1));
        }
        return null;
    }

    public static String extractRootSignature(String json) {
        if (json == null) {
            return null;
        }
        int idx = json.lastIndexOf("\"signature\"");
        if (idx < 0) {
            return null;
        }
        return extractString(json.substring(idx), "signature");
    }

    public static String extractRootCode(String json) {
        if (json == null) {
            return null;
        }
        Pattern pattern = Pattern.compile("^\\s*\\{\\s*\"code\"\\s*:\\s*\"((?:\\\\.|[^\"\\\\])*)\"");
        Matcher matcher = pattern.matcher(json.trim());
        if (matcher.find()) {
            return unescapeJson(matcher.group(1));
        }
        return extractString(json, "code");
    }

    public static Long extractLong(String json, String key) {
        Pattern pattern = Pattern.compile("\"" + Pattern.quote(key) + "\"\\s*:\\s*(-?\\d+)");
        Matcher matcher = pattern.matcher(json);
        if (matcher.find()) {
            return Long.parseLong(matcher.group(1));
        }
        return null;
    }

    public static String extractDataObject(String json) {
        int start = json.indexOf("\"data\"");
        if (start < 0) {
            return null;
        }
        int braceStart = json.indexOf('{', start);
        if (braceStart < 0) {
            return null;
        }
        int depth = 0;
        for (int i = braceStart; i < json.length(); i++) {
            char c = json.charAt(i);
            if (c == '{') {
                depth++;
            } else if (c == '}') {
                depth--;
                if (depth == 0) {
                    return json.substring(braceStart, i + 1);
                }
            }
        }
        return null;
    }

    public static Map<String, String> parseFlatObject(String jsonObject) {
        Map<String, String> map = new TreeMap<>();
        if (jsonObject == null) {
            return map;
        }
        Pattern pattern = Pattern.compile("\"([^\"]+)\"\\s*:\\s*(\"((?:\\\\.|[^\"\\\\])*)\"|(-?\\d+(?:\\.\\d+)?)|true|false|null)");
        Matcher matcher = pattern.matcher(jsonObject);
        while (matcher.find()) {
            String key = matcher.group(1);
            String quoted = matcher.group(3);
            String number = matcher.group(4);
            if (quoted != null) {
                map.put(key, unescapeJson(quoted));
            } else if (number != null) {
                map.put(key, number);
            } else if ("true".equals(matcher.group(2))) {
                map.put(key, "true");
            } else if ("false".equals(matcher.group(2))) {
                map.put(key, "false");
            } else {
                map.put(key, "");
            }
        }
        return map;
    }

    public static String toSignatureString(Map<String, String> sortedData) {
        StringBuilder sb = new StringBuilder();
        boolean first = true;
        for (Map.Entry<String, String> entry : sortedData.entrySet()) {
            if (!first) {
                sb.append('&');
            }
            String value = entry.getValue();
            if (value == null || "null".equalsIgnoreCase(value) || "undefined".equalsIgnoreCase(value)) {
                value = "";
            }
            sb.append(entry.getKey()).append('=').append(value);
            first = false;
        }
        return sb.toString();
    }

    private static String unescapeJson(String value) {
        return value.replace("\\\"", "\"")
                .replace("\\\\", "\\")
                .replace("\\n", "\n")
                .replace("\\r", "\r");
    }
}