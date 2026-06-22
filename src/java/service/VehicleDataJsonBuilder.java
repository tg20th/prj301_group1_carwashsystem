package service;

import dto.VehicleBrand;
import dto.VehicleModel;
import java.util.List;

public final class VehicleDataJsonBuilder {

    private VehicleDataJsonBuilder() {
    }

    public static String buildCatalogJson(List<VehicleBrand> brands, List<VehicleModel> models) {
        StringBuilder json = new StringBuilder("{\"brands\":[");
        for (int i = 0; i < brands.size(); i++) {
            VehicleBrand brand = brands.get(i);
            if (i > 0) {
                json.append(",");
            }
            json.append("{\"brandID\":").append(brand.getBrandID())
                    .append(",\"brandName\":\"").append(escape(brand.getBrandName())).append("\"}");
        }
        json.append("],\"models\":[");
        for (int i = 0; i < models.size(); i++) {
            VehicleModel model = models.get(i);
            if (i > 0) {
                json.append(",");
            }
            json.append("{\"modelID\":").append(model.getModelID())
                    .append(",\"brandID\":").append(model.getBrandID())
                    .append(",\"modelName\":\"").append(escape(model.getModelName())).append("\"}");
        }
        json.append("]}");
        return json.toString();
    }

    private static String escape(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}