/*
Claeaning data in SQL Queries
*/

Select *
from Portfolio_Project..NashvilleHousing

-- Standardize Data Format

Select SaleDateConverted, CONVERT(Date, SaleDate)
from Portfolio_Project..NashvilleHousing

Alter table Nashvillehousing
Add SaleDateConverted Date;

Update NashvilleHousing
set SaleDateconverted = CONVERT(Date, SaleDate)

-- Populate Property Address data

Select *
from Portfolio_Project..NashvilleHousing
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
from Portfolio_Project..NashvilleHousing a
Join Portfolio_Project..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	And a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from Portfolio_Project..NashvilleHousing a
Join Portfolio_Project..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	And a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null



-- Breaking Out Address Into Individual Columns(Address, City, State)

Select PropertyAddress
from Portfolio_Project..NashvilleHousing
--order by ParcelID

Select SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) As Address
, Substring(PropertyAddress, Charindex(',', PropertyAddress) +1, Len(PropertyAddress)) As Address

From Portfolio_Project..NashvilleHousing


Alter table Nashvillehousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


Alter table Nashvillehousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
set PropertySplitCity = Substring(PropertyAddress, Charindex(',', PropertyAddress) +1, Len(PropertyAddress))

Select *
From Portfolio_Project..NashvilleHousing


Select OwnerAddress
from Portfolio_Project..NashvilleHousing

Select
Parsename(Replace(OwnerAddress, ',', '.'), 3)
, Parsename(Replace(OwnerAddress, ',', '.'), 2)
, Parsename(Replace(OwnerAddress, ',', '.'), 1)
From portfolio_Project..NashvilleHousing


Alter table Nashvillehousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
set OwnerSplitAddress = Parsename(Replace(OwnerAddress, ',', '.'), 3)

Alter table Nashvillehousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
set OwnerSplitCity = Parsename(Replace(OwnerAddress, ',', '.'), 2)

Alter table Nashvillehousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
set OwnerSplitState = Parsename(Replace(OwnerAddress, ',', '.'), 1)

Select *
From Portfolio_Project..NashvilleHousing


-- Change Y and N to Yes and No in "Solid as Vacant" Field

Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From Portfolio_Project..NashvilleHousing
Group by SoldAsVacant
order by 2

Select SoldAsVacant
, Case When SoldAsVacant = 'Y' Then 'Yes'
	   When SoldAsVacant = 'N' then 'No'
	   Else SoldAsVacant
	   End
From portfolio_Project..NashvilleHousing

Update NashvilleHousing 
Set SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
	   When SoldAsVacant = 'N' then 'No'
	   Else SoldAsVacant
	   End


--Remove Duplicates

With RownumCTE As(
Select *,
	ROW_NUMBER() Over(
	Partition By ParcelID, 
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order by
				    UniqueID
					)  Row_num

From Portfolio_Project..NashvilleHousing
--Order By ParcelID
)
Delete
From RownumCTE
Where Row_num >1
--Order by PropertyAddress


With RownumCTE As(
Select *,
	ROW_NUMBER() Over(
	Partition By ParcelID, 
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order by
				    UniqueID
					)  Row_num

From Portfolio_Project..NashvilleHousing
--Order By ParcelID
)
Select *
From RownumCTE
Where Row_num >1
Order by PropertyAddress


--Delete Unused Columns

Select *
From Portfolio_Project..NashvilleHousing

Alter Table Portfolio_Project..NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress

Alter Table Portfolio_Project..NashvilleHousing
Drop Column SaleDate
