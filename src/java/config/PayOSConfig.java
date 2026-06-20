package config;

import java.io.InputStream;
import java.util.Properties;
import javax.servlet.ServletContext;

public final class PayOSConfig {

    private static final Properties PROPS = new Properties();
    private static boolean loaded;

    private PayOSConfig() {
    }

    public static synchronized void load(ServletContext context) {
        if (loaded) {
            return;
        }
        try (InputStream in = context.getResourceAsStream("/WEB-INF/payos.properties")) {
            if (in != null) {
                PROPS.load(in);
                loaded = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static String get(String key) {
        return PROPS.getProperty(key, "").trim();
    }

    public static String clientId() {
        return get("payos.client.id");
    }

    public static String apiKey() {
        return get("payos.api.key");
    }

    public static String checksumKey() {
        return get("payos.checksum.key");
    }

    public static String baseUrl() {
        String url = get("payos.base.url");
        return url.isEmpty() ? "https://api-merchant.payos.vn" : url;
    }

    public static String returnBaseUrl() {
        return get("payos.return.base.url");
    }

    /** URL bạn mở app trên trình duyệt (giữ session). Thường là localhost, khác ngrok. */
    public static String appUrl() {
        String url = get("payos.app.url");
        if (url.isEmpty()) {
            url = returnBaseUrl();
        }
        return trimTrailingSlash(url);
    }

    public static String appPath(String path) {
        String base = appUrl();
        if (path == null || path.isEmpty()) {
            return base;
        }
        return base + (path.startsWith("/") ? path : "/" + path);
    }

    private static String trimTrailingSlash(String url) {
        if (url == null || url.isEmpty()) {
            return "";
        }
        return url.endsWith("/") ? url.substring(0, url.length() - 1) : url;
    }

    public static boolean isConfigured() {
        return !clientId().isEmpty() && !apiKey().isEmpty() && !checksumKey().isEmpty();
    }

    /** Bật để test thanh toán giả lập — không chuyển tiền thật. Tắt khi deploy production. */
    public static boolean sandboxMode() {
        return "true".equalsIgnoreCase(get("payos.sandbox.mode"));
    }
}