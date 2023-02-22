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
	{ Name = "10 Wins", Value = 10, ProductId = "1380843069", Type = "Wins" },
	{ Name = "100 Wins", Value = 100, ProductId = "1380843214", Type = "Wins" },
	{ Name = "500 Wins", Value = 500, ProductId = "1380843332", Type = "Wins" },
	{ Name = "1000 Wins", Value = 1000, ProductId = "1380843435", Type = "Wins" },

	-----FartPower Table-----
	{ Name = "100 FartPower", Value = 100, ProductId = "1380845985", Type = "FartPower" },
	{ Name = "1000 FartPower", Value = 1000, ProductId = "1380846081", Type = "FartPower" },
	{ Name = "5000 FartPower", Value = 5000, ProductId = "1380846326", Type = "FartPower" },

	----+ 1 FartPower Every Seconds Table------
	{ Name = "1 FartIncrease", Value = 1, ProductId = "1380843816", Type = "FartIncrease" },
	{ Name = "10 FartIncrease", Value = 10, ProductId = "1380844143", Type = "FartIncrease" },

	----Nuke Table-----
	{ Name = "Nuke", ProductId = "1380844202", Type = "Nuke" },
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
		if Product.ProductId == ProductId then --- If ProductId is the same as Product.ProductId
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
return DevProducts
