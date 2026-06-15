import os
from fastapi import APIRouter, Depends, UploadFile, File, HTTPException, status
from fastapi.responses import FileResponse
from app.config import settings
from app.schemas.upload import UploadResponse
from app.services.upload_service import UploadService
from app.routers.deps import get_current_user
from app.models.user import User

router = APIRouter(prefix="/upload", tags=["Uploads"])

@router.post("/image", response_model=UploadResponse, status_code=status.HTTP_201_CREATED)
async def upload_image(
    file: UploadFile = File(...),
    current_user: User = Depends(get_current_user)  # Protected by JWT
):
    image_url, filename, size_bytes = await UploadService.save_uploaded_file(file)
    return UploadResponse(
        image_url=image_url,
        filename=filename,
        size_bytes=size_bytes
    )

@router.get("/{filename}")
def get_uploaded_image(filename: str):
    file_path = os.path.join(settings.UPLOAD_DIR, filename)
    if not os.path.exists(file_path):
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="File not found"
        )
    return FileResponse(file_path)
