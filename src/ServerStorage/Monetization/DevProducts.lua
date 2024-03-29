---**Compare Words Function To Check If They Are the Same**---
local function CompareWords(Name1, Name2)
	local FilteredName1 = string.lower(Name1:gsub("%s+", "")) --Remove Spaces and make lowerspace
	local FilteredName2 = string.lower(Name2:gsub("%s+", "")) --Remove Spaces and make lowerspace
	if FilteredName1 == FilteredName2 then --If Names Are The Same
		return true --Return True
	else
		return false --Return False
	end
end

------*Module------
local DevProducts = {}
DevProducts.__index = DevProducts

DevProducts.ProductsTable = {

	------Wins Table-----
	{ Name = "10 Wins", Value = 10, ProductId = "1380843104", Type = "Wins" },
	{ Name = "100 Wins", Value = 100, ProductId = "1380843184", Type = "Wins" },
	{ Name = "500 Wins", Value = 500, ProductId = "1380843287", Type = "Wins" },
	{ Name = "1000 Wins", Value = 1000, ProductId = "1380843400", Type = "Wins" },

	-----FartPower Table-----
	{ Name = "100 FartPower", Value = 100, ProductId = "1380847270", Type = "FartPower" },
	{ Name = "1000 FartPower", Value = 1000, ProductId = "1380847336", Type = "FartPower" },
	{ Name = "5000 FartPower", Value = 5000, ProductId = "1380847419", Type = "FartPower" },

	----+ 1 FartPower Every Seconds Table------
	{ Name = "1 FartIncrease", Value = 1, ProductId = "1380843882", Type = "FartIncrease" },
	{ Name = "10 FartIncrease", Value = 10, ProductId = "1380843976", Type = "FartIncrease" },

	----Nuke Table-----
	{ Name = "Nuke", ProductId = "1380844242", Type = "Nuke" },
}

-----**Function To Get ProductId by Name-----
function DevProducts:GetProductId(ProductName)
	for i, Product in pairs(self.ProductsTable) do --- Loop through ProductsTable
		if CompareWords(Product.Name, ProductName) then --- If ProductName is the same as Product.Name
			return Product.ProductId --- Return ProductId
		end
	end
end

-----**Function To Get ProductInfo by ProductId-----
function DevProducts:GetProductInfoTableByProductId(ProductId)
	for i, Product in pairs(self.ProductsTable) do --- Loop through ProductsTable
		if tonumber(Product.ProductId) == tonumber(ProductId) then --- If ProductId is the same as Product.ProductId
			return Product --- Return Product
		end
	end
end

------** Write a function that can retrun the productid by type and value
function DevProducts:GetProductIdByTypeAndValue(Type, Value)
	for i, Product in pairs(self.ProductsTable) do --- Loop through ProductsTable
		if Product.Type == Type and Product.Value == Value then --- If ProductId is the same as Product.ProductId
			return Product.ProductId --- Return ProductId
		end
	end
end

--------**Function to get the Nearest Product Id by type and value**-------
function DevProducts:GetNearestProductIdByTypeAndValue(Type, PlayerValue, ProductValue)
	local Difference = ProductValue - PlayerValue
	local NearestProductId = nil
	local NearestDifference = nil

	-- Loop through ProductsTable
	for i, Product in pairs(self.ProductsTable) do
		-- Check if Product type is equal to the given type and value is greater than or equal to the difference

		if Product.Type == Type and Product.Value >= Difference then
			-- If NearestDifference is not set yet, set it
			if NearestDifference == nil then
				NearestDifference = Product.Value - Difference
				NearestProductId = Product.ProductId

			-- Else check if current product has a value closer to the difference
			elseif Product.Value - Difference < NearestDifference then
				NearestDifference = Product.Value - Difference
				NearestProductId = Product.ProductId
			end

		-- Check if Product type is equal and value is smaller than difference and NearestDifference is not set yet so it returns the biggest prodcut value
		elseif Product.Type == Type and Product.Value < Difference and NearestDifference == nil then
			NearestProductId = Product.ProductId
		end
	end

	return NearestProductId
end

return DevProducts
