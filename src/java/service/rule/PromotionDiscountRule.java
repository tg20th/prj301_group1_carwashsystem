package service.rule;

import dao.PromotionDAO;
import dto.DiscountRequest;
import dto.DiscountResult;
import dto.Promotion;
import java.util.List;

public class PromotionDiscountRule {

    private final PromotionDAO promotionDAO = new PromotionDAO();

    public List<Promotion> getEligiblePromotions(int customerId, int tierId) {
        return promotionDAO.getApplicablePromotions(customerId, tierId);
    }

    public DiscountResult apply(DiscountRequest request) {
        long subTotal = Math.max(0, request.getSubTotal());
        DiscountResult result = new DiscountResult(subTotal, 0, subTotal);

        List<Promotion> eligible = getEligiblePromotions(request.getCustomerId(), request.getTierId());
        if (eligible.isEmpty()) {
            return result;
        }

        Promotion selected = resolvePromotion(request.getPromotionId(), eligible);
        if (selected == null) {
            return result;
        }

        int percent = Math.max(0, Math.min(100, selected.getDiscountPercent()));
        long discountAmount = Math.round(subTotal * percent / 100.0);
        long finalAmount = Math.max(0, subTotal - discountAmount);

        result.setDiscountAmount(discountAmount);
        result.setFinalAmount(finalAmount);
        result.setAppliedPromotionId(selected.getPromotionID());
        result.setPromotionName(selected.getPromotionName());
        result.setDiscountPercent(percent);
        return result;
    }

    private Promotion resolvePromotion(Integer promotionId, List<Promotion> eligible) {
        if (promotionId != null && promotionId > 0) {
            for (Promotion p : eligible) {
                if (p.getPromotionID() == promotionId) {
                    return p;
                }
            }
            return null;
        }

        Promotion best = null;
        for (Promotion p : eligible) {
            if (best == null || p.getDiscountPercent() > best.getDiscountPercent()) {
                best = p;
            }
        }
        return best;
    }
}