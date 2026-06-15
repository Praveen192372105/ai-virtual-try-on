from sqlalchemy.orm import Session
from typing import List, Optional
from app.models.product import Product
from app.schemas.product import ProductCreate, ProductUpdate

class ProductService:
    @staticmethod
    def get_product(db: Session, product_id: int) -> Optional[Product]:
        return db.query(Product).filter(Product.id == product_id).first()

    @staticmethod
    def get_products(
        db: Session, 
        search: Optional[str] = None, 
        category: Optional[str] = None, 
        skip: int = 0, 
        limit: int = 100
    ) -> List[Product]:
        query = db.query(Product)
        if search:
            query = query.filter(Product.name.ilike(f"%{search}%"))
        if category:
            query = query.filter(Product.category.ilike(category))
        return query.offset(skip).limit(limit).all()

    @staticmethod
    def get_products_by_category(
        db: Session, 
        category: str, 
        skip: int = 0, 
        limit: int = 100
    ) -> List[Product]:
        return db.query(Product).filter(Product.category.ilike(category)).offset(skip).limit(limit).all()

    @staticmethod
    def create_product(db: Session, product_in: ProductCreate) -> Product:
        db_product = Product(
            name=product_in.name,
            category=product_in.category,
            brand=product_in.brand,
            description=product_in.description,
            image_url=product_in.image_url,
            price=product_in.price
        )
        db.add(db_product)
        db.commit()
        db.refresh(db_product)
        return db_product

    @staticmethod
    def update_product(db: Session, product_id: int, product_in: ProductUpdate) -> Optional[Product]:
        db_product = db.query(Product).filter(Product.id == product_id).first()
        if not db_product:
            return None
        
        update_data = product_in.model_dump(exclude_unset=True)
        for field, value in update_data.items():
            setattr(db_product, field, value)
            
        db.commit()
        db.refresh(db_product)
        return db_product

    @staticmethod
    def delete_product(db: Session, product_id: int) -> bool:
        db_product = db.query(Product).filter(Product.id == product_id).first()
        if not db_product:
            return False
            
        db.delete(db_product)
        db.commit()
        return True
