import os
import uuid
import aiofiles
from fastapi import UploadFile, HTTPException, status
from app.config import settings

ALLOWED_EXTENSIONS = {".png", ".jpg", ".jpeg"}
MAX_FILE_SIZE_BYTES = 5 * 1024 * 1024  # 5 Megabytes

class UploadService:
    @staticmethod
    def validate_file(file: UploadFile) -> str:
        # Check file extension
        _, ext = os.path.splitext(file.filename.lower())
        if ext not in ALLOWED_EXTENSIONS:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"Unsupported file format. Supported extensions are: {', '.join(ALLOWED_EXTENSIONS)}"
            )
        return ext

    @staticmethod
    async def save_uploaded_file(file: UploadFile) -> tuple[str, str, int]:
        # Validate extension
        ext = UploadService.validate_file(file)
        
        # Read and check size
        contents = await file.read()
        size_bytes = len(contents)
        if size_bytes > MAX_FILE_SIZE_BYTES:
            raise HTTPException(
                status_code=status.HTTP_413_REQUEST_ENTITY_TOO_LARGE,
                detail=f"File is too large. Max allowed size is {MAX_FILE_SIZE_BYTES / (1024 * 1024)}MB."
            )
            
        # Reset file cursor after reading
        await file.seek(0)
        
        # Generate unique file name
        unique_filename = f"{uuid.uuid4().hex}{ext}"
        
        # Ensure uploads folder exists
        os.makedirs(settings.UPLOAD_DIR, exist_ok=True)
        file_path = os.path.join(settings.UPLOAD_DIR, unique_filename)
        
        # Async write file to disk
        async with aiofiles.open(file_path, "wb") as out_file:
            await out_file.write(contents)
            
        # Return URL relative path, filename, and size
        image_url = f"/uploads/{unique_filename}"
        return image_url, unique_filename, size_bytes
