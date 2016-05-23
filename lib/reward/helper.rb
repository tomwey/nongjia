module Reward
  class Helper
    
    def self.calcu_rewards(money, stragy)
      money = money.to_f
      return 0 if money <= 0 or stragy.blank?
      if stragy.include? ':'
        partial = stragy.split(':')
        if partial.count != 3
          return 0
        else
          min = partial[0].to_f
          limit = partial[1].to_f
          max = partial[2].to_f
          if min > max
            return 0
          else
            return min if money <= limit
            return max
          end
        end
      else
        if stragy.to_f < 1 # 按金额的百分比计算
          return money * stragy.to_f
        else # 按固定值提现
          return stragy.to_f
        end
      end
    end
    
  end
end