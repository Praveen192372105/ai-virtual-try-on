from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime

class TryOnRequest(BaseModel):
    product_id: int = Field(..., description="ID of the product being tried on")
    uploaded_image: str = Field(..., description="Stored path/URL of the uploaded user image")

class TryOnResponse(BaseModel):
    id: int
    user_id: int
    product_id: Optional[int] = None
    uploaded_image: str
    generated_image: Optional[str] = None
    status: str = Field("pending", description="AI processing status: pending, processing, completed, failed")
    created_at: datetime

    class Config:
        from_attributes = True
