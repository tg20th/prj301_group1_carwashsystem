package dto;

public class VehicleModel {

    private int modelID;
    private int brandID;

    private String modelName;

    public VehicleModel() {
    }

    public VehicleModel(int modelID, int brandID, String modelName) {
        this.modelID = modelID;
        this.brandID = brandID;
        this.modelName = modelName;
    }

    public int getModelID() {
        return modelID;
    }

    public void setModelID(int modelID) {
        this.modelID = modelID;
    }

    public int getBrandID() {
        return brandID;
    }

    public void setBrandID(int brandID) {
        this.brandID = brandID;
    }

    public String getModelName() {
        return modelName;
    }

    public void setModelName(String modelName) {
        this.modelName = modelName;
    }
}