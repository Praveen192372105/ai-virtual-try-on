from sqlalchemy import Column, Integer, String, Float, Text, DateTime
from sqlalchemy.orm import relationship
from datetime import datetime

from app.database import Base

class Product(Base):
    __tablename__ = "products"

    id          = Column(Integer, primary_key=True, index=True)
    name        = Column(String(200), nullable=False, index=True)
    category    = Column(String(100), nullable=True, index=True)
    brand       = Column(String(100), nullable=True, index=True)
    description = Column(Text, nullable=True)
    image_url   = Column(String(500), nullable=True)
    price       = Column(Float, nullable=False)
    created_at  = Column(DateTime, default=datetime.utcnow)

    # Relationships
    tryon_histories = relationship("TryOnHistory", back_populates="product")

    def __repr__(self):
        return f"<Product id={self.id} name={self.name}>"
