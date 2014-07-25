class HomeController < ApplicationController
  def index
  	@query = params[:query] == "" ? 1 : params[:query]
  	@currency1 = params[:to] || "USD"
  	@currency2 = params[:co] || "BRL"
  	@answer = CurrencyConverter.converter(1, "USD", "BRL")

  	if @query
  		#@arg = @query.split(" ")  	
  		#@answer = CurrencyConverter.converter(@arg[0], @arg[1], @arg[2])
  		@answer = CurrencyConverter.converter(@query, @currency1, @currency2)
  	end  	
      
    respond_to do |format|
      format.html # index.html.erb
      format.js
    end
  end
end
