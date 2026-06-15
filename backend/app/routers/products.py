from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.orm import Session
from typing import List, Optional

from app.database import get_db
from app.schemas.product import ProductCreate, ProductUpdate, ProductResponse
from app.services.product_service import ProductService
from app.routers.deps import get_current_user
from app.models.user import User

router = APIRouter(prefix="/products", tags=["Products"])

@router.get("", response_model=List[ProductResponse])
def read_products(
    search: Optional[str] = Query(None, description="Search products by name"),
    category: Optional[str] = Query(None, description="Filter products by category"),
    skip: int = Query(0, ge=0, description="Number of products to skip"),
    limit: int = Query(50, ge=1, le=100, description="Maximum number of products to return"),
    db: Session = Depends(get_db)
):
    return ProductService.get_products(db, search=search, category=category, skip=skip, limit=limit)

@router.get("/category/{category}", response_model=List[ProductResponse])
def read_products_by_category(
    category: str,
    skip: int = Query(0, ge=0),
    limit: int = Query(50, ge=1, le=100),
    db: Session = Depends(get_db)
):
    return ProductService.get_products_by_category(db, category=category, skip=skip, limit=limit)

@router.get("/{product_id}", response_model=ProductResponse)
def read_product(product_id: int, db: Session = Depends(get_db)):
    product = ProductService.get_product(db, product_id=product_id)
    if not product:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Product not found"
        )
    return product

@router.post("", response_model=ProductResponse, status_code=status.HTTP_201_CREATED)
def create_product(
    product_in: ProductCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)  # Protected by JWT
):
    return ProductService.create_product(db, product_in=product_in)

@router.put("/{product_id}", response_model=ProductResponse)
def update_product(
    product_id: int,
    product_in: ProductUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)  # Protected by JWT
):
    product = ProductService.update_product(db, product_id=product_id, product_in=product_in)
    if not product:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Product not found"
        )
    return product

@router.delete("/{product_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_product(
    product_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)  # Protected by JWT
):
    success = ProductService.delete_product(db, product_id=product_id)
    if not success:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Product not found"
        )
    return None
