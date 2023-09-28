Select *
From [Portfolio Project].dbo.NashvilleHousing

-- Standardize Date Format
Select SaleDateConverted
From [Portfolio Project].dbo.NashvilleHousing


Update NashvilleHousing
SET Saledate = Convert(Date, Saledate)

Alter Table Nashvillehousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = Convert(Date, Saledate)

-- Populate Property Address Data

Select *
From [Portfolio Project].dbo.NashvilleHousing
--where PropertyAddress is null]
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From [Portfolio Project].dbo.NashvilleHousing a
JOIN [Portfolio Project].dbo.NashvilleHousing b
     on a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From [Portfolio Project].dbo.NashvilleHousing a
JOIN [Portfolio Project].dbo.NashvilleHousing b
     on a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]


-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From [Portfolio Project]..NashvilleHousing


Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) As Address

From [Portfolio Project]..NashvilleHousing

Alter Table Nashvillehousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

Alter Table Nashvillehousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))


Select *
From [Portfolio Project]..NashvilleHousing


Select OwnerAddress
From [Portfolio Project]..NashvilleHousing

Select
Parsename(Replace(Owneraddress, ',', '.'), 3)
,Parsename(Replace(Owneraddress, ',', '.'), 2)
,Parsename(Replace(Owneraddress, ',', '.'), 1)
From [Portfolio Project]..NashvilleHousing

Alter Table Nashvillehousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = Parsename(Replace(Owneraddress, ',', '.'), 3)

Alter Table Nashvillehousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = Parsename(Replace(Owneraddress, ',', '.'), 2)

Alter Table Nashvillehousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = Parsename(Replace(Owneraddress, ',', '.'), 1)


-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From [Portfolio Project]..NashvilleHousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant,
  Case When SoldAsVacant = 'Y' Then 'Yes'
       When SoldAsVacant = 'N' Then 'No'
	   Else SoldAsVacant
	   End
from [Portfolio Project]..NashvilleHousing

Update NashvilleHousing
Set SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
       When SoldAsVacant = 'N' Then 'No'
	   Else SoldAsVacant
	   End
from [Portfolio Project]..NashvilleHousing


-- Remove Duplicates

With RowNumCTE AS(
Select *,
    Row_Number() Over(
	Partition by ParcelID,
	             PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order by
				   UniqueId
				   ) row_num
From [Portfolio Project]..NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress


-- Delete Unused Columns

Select *
From [Portfolio Project]..NashvilleHousing

Alter Table [Portfolio Project]..NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress

Alter Table [Portfolio Project]..NashvilleHousing
Drop Column SaleDate