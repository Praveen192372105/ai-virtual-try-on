from pydantic import BaseModel

class UploadResponse(BaseModel):
    image_url: str
    filename: str
    size_bytes: int

    class Config:
        from_attributes = True
