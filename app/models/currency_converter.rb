class CurrencyConverter
	@bank = MoneyRails.default_bank
	@bank.update_rates

	def self.converter(money, currency1, currency2)
		unless @bank.rates.length == 0
			m = money.to_money.fractional
			c = @bank.exchange(m, currency1, currency2).format
			"#{Money.new(m, currency1).format} = #{c}"
		else
		 	"Unable to Update Rates Right Now, Please Try Again In a While."
		end
	end
end