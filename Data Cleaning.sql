-- Select all table data
SELECT *
FROM portfolio.dbo.NashvilleHousing

-- Change SaleDate from Datetime format to Date
ALTER TABLE NashvilleHousing
ADD SalesDate DATE

UPDATE NashvilleHousing
SET SalesDate = CONVERT(DATE, SaleDate)

-- Check changes
SELECT *
FROM portfolio.dbo.NashvilleHousing

-- Update null values in PropertyAddress 
SELECT *
FROM portfolio.dbo.NashvilleHousing
WHERE PropertyAddress IS NULL
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, a.ParcelID, a.PropertyAddress
FROM portfolio.dbo.NashvilleHousing a
JOIN
portfolio.dbo.NashvilleHousing b
ON 
a.ParcelID = b.ParcelID
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM Portfolio.dbo.NashvilleHousing a
JOIN Portfolio.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

-- Check changes
SELECT *
FROM portfolio.dbo.NashvilleHousing

-- Separate Addresses into Individual Columns (Address, City, State)
ALTER TABLE NashvilleHousing
ADD PropertyCity VARCHAR(100),
    PropertyAddressNew VARCHAR(100),
	OwnerCity VARCHAR(100),
	OwnerState VARCHAR(100),
	OwnerAddressNew VARCHAR(100)

--Check new columns
SELECT *
FROM Portfolio.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET
PropertyAddressNew = PARSENAME(REPLACE(PropertyAddress, ',', '.') , 2),
PropertyCity = PARSENAME(REPLACE(PropertyAddress, ',', '.') , 1)
FROM Portfolio.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET
OwnerAddressNew = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3),
OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2),
OwnerState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
FROM Portfolio.dbo.NashvilleHousing

-- Check changes
SELECT *
FROM portfolio.dbo.NashvilleHousing

-- Change Y and N to Yes and No in SoldasVacant
SELECT SoldAsVacant, Count(SoldAsVacant)
FROM Portfolio.dbo.NashvilleHousing
GROUP BY SoldAsVacant

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
					    WHEN SoldAsVacant = 'N' THEN 'No'
						ELSE SoldAsVacant
						END
-- Check changes
SELECT SoldAsVacant, Count(SoldAsVacant)
FROM Portfolio.dbo.NashvilleHousing
GROUP BY SoldAsVacant

-- Remove Duplicate rows
WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY UniqueID) row_num
FROM Portfolio.dbo.NashvilleHousing
)
DELETE
FROM RowNumCTE
WHERE row_num > 1

-- Check Changes
WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY UniqueID) row_num
FROM Portfolio.dbo.NashvilleHousing
)

SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress


-- Delete Unused Columns
ALTER TABLE NashvilleHousing
DROP COLUMN PropertyAddress,
		    SaleDate,
			OwnerAddress

-- Check Changes
SELECT *
FROM Portfolio.dbo.NashvilleHousing