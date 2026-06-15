from sqlalchemy import Column, Integer, String, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from datetime import datetime

from app.database import Base

class TryOnHistory(Base):
    __tablename__ = "tryon_histories"

    id              = Column(Integer, primary_key=True, index=True)
    user_id         = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    product_id      = Column(Integer, ForeignKey("products.id", ondelete="SET NULL"), nullable=True, index=True)
    uploaded_image  = Column(String(500), nullable=False)
    generated_image = Column(String(500), nullable=True)
    created_at      = Column(DateTime, default=datetime.utcnow)

    # Relationships
    user    = relationship("User", back_populates="tryon_histories")
    product = relationship("Product", back_populates="tryon_histories")

    def __repr__(self):
        return f"<TryOnHistory id={self.id} user_id={self.user_id} product_id={self.product_id}>"
