package service;

import dto.DiscountRequest;
import dto.DiscountResult;
import dto.Promotion;
import java.util.List;
import service.rule.PromotionDiscountRule;

public class DiscountEngine {

    private final PromotionDiscountRule promotionRule = new PromotionDiscountRule();

    public List<Promotion> getEligiblePromotions(int customerId, int tierId) {
        return promotionRule.getEligiblePromotions(customerId, tierId);
    }

    public DiscountResult calculate(DiscountRequest request) {
        if (request == null) {
            return new DiscountResult(0, 0, 0);
        }
        return promotionRule.apply(request);
    }
}