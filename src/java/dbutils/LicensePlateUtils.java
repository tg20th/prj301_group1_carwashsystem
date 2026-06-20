package dbutils;

public class LicensePlateUtils {

    private static final String PATTERN = "\\d{2}[A-Z]-\\d{5}";
    public static final String FORMAT_MESSAGE =
            "License plate must be in format 63A-12345 (2 digits, 1 letter, hyphen, 5 digits).";

    private LicensePlateUtils() {
    }

    public static String normalize(String plate) {
        if (plate == null) {
            return null;
        }
        return plate.trim().toUpperCase();
    }

    public static boolean isValid(String plate) {
        String normalized = normalize(plate);
        return normalized != null && !normalized.isEmpty() && normalized.matches(PATTERN);
    }
}