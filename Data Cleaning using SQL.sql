/*
	
	Cleaning Data in SQL Queries

*/

Select *
From PortfolioProject..NashvilleHousing

--Change Date Format

Select SaleDate, convert(Date,SaleDate)
From PortfolioProject..NashvilleHousing

Update NashvilleHousing
Set SaleDate = convert(Date,SaleDate)

/*Select SaleDate 
From PortfolioProject..NashvilleHousing*/

Alter Table NashvilleHousing
Add SaleDateConverted Date

Update NashvilleHousing
Set SaleDateConverted = convert(Date,SaleDate)

Select SaleDateConverted 
From PortfolioProject..NashvilleHousing

--Populate Property Address Data

Select *
From PortfolioProject..NashvilleHousing
--Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
Join PortfolioProject..NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] != b.[UniqueID ]
where a.PropertyAddress is null

Update a 
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
Join PortfolioProject..NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] != b.[UniqueID ]
where a.PropertyAddress is null


--Breaking out Address into Individual Columns (Address, City, State)

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as Address
From PortfolioProject..NashvilleHousing

Alter Table NashvilleHousing
Add PropertySplitAddress Nvarchar(255)

Update NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)

Alter Table NashvilleHousing
Add PropertySplitCity Nvarchar(255)

Update NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

Select *
From PortfolioProject .. NashvilleHousing

Select OwnerAddress
From PortfolioProject .. NashvilleHousing

Select 
PARSENAME(REPLACE(OwnerAddress, ',' , '.') , 3)
, PARSENAME(REPLACE(OwnerAddress, ',' , '.') , 2)
, PARSENAME(REPLACE(OwnerAddress, ',' , '.') , 1)
From PortfolioProject .. NashvilleHousing

Alter Table NashvilleHousing
Add OwnerSplitAddress Nvarchar(255)

Update NashvilleHousing
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',' , '.') , 3)

Alter Table NashvilleHousing
Add OwnerSplitCity Nvarchar(255)

Update NashvilleHousing
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',' , '.') , 2)

Alter Table NashvilleHousing
Add OwnerSplitState Nvarchar(255)

Update NashvilleHousing
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',' , '.') , 1)

Select *
From PortfolioProject .. NashvilleHousing


--Change Y and N to Yes and No in "SoldAsVacant" Field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject .. NashvilleHousing
Group by SoldAsVacant
order by 2

Select SoldAsVacant,
Case When SoldAsVacant = 'Y' Then 'Yes'
	 When SoldAsVacant = 'N' Then 'No'
	 Else SoldAsVacant
	 End
From PortfolioProject .. NashvilleHousing

Update NashvilleHousing
Set SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
	 When SoldAsVacant = 'N' Then 'No'
	 Else SoldAsVacant
	 End


--Remove Duplicates

With RowNumCTE As(
Select *,
  ROW_NUMBER() Over(
  Partition By ParcelID,PropertyAddress,SalePrice,SaleDate,LegalReference Order by UniqueID
  ) rownum
From PortfolioProject..NashvilleHousing
)
Delete 
From RowNumCTE
Where rownum >1


--Delete Unused Columns

Select *
From PortfolioProject..NashvilleHousing

Alter Table PortfolioProject..NashvilleHousing
Drop Column PropertyAddress, OwnerAddress, TaxDistrict

Alter Table PortfolioProject..NashvilleHousing
Drop Column SaleDate

