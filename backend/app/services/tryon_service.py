import time
import os
import shutil
from sqlalchemy.orm import Session
from typing import List, Optional
from fastapi import BackgroundTasks

from app.models.tryon_history import TryOnHistory
from app.models.product import Product
from app.config import settings

class TryOnService:
    @staticmethod
    def get_tryon_by_id(db: Session, tryon_id: int, user_id: int) -> Optional[TryOnHistory]:
        return db.query(TryOnHistory).filter(
            TryOnHistory.id == tryon_id, 
            TryOnHistory.user_id == user_id
        ).first()

    @staticmethod
    def get_user_history(db: Session, user_id: int, skip: int = 0, limit: int = 100) -> List[TryOnHistory]:
        return db.query(TryOnHistory).filter(
            TryOnHistory.user_id == user_id
        ).order_by(TryOnHistory.created_at.desc()).offset(skip).limit(limit).all()

    @staticmethod
    def start_tryon_process(
        db: Session, 
        user_id: int, 
        product_id: int, 
        uploaded_image: str,
        background_tasks: BackgroundTasks
    ) -> TryOnHistory:
        # Create a pending try-on history record
        db_tryon = TryOnHistory(
            user_id=user_id,
            product_id=product_id,
            uploaded_image=uploaded_image,
            status="pending"
        )
        db.add(db_tryon)
        db.commit()
        db.refresh(db_tryon)
        
        # Enqueue the placeholder AI processing task to run in the background
        background_tasks.add_task(
            TryOnService._mock_ai_processing,
            db_tryon.id,
            uploaded_image,
            product_id
        )
        
        return db_tryon

    @staticmethod
    def _mock_ai_processing(tryon_id: int, uploaded_image: str, product_id: int):
        # We open a new database session inside the background task since it runs asynchronously
        from app.database import SessionLocal
        db = SessionLocal()
        try:
            db_tryon = db.query(TryOnHistory).filter(TryOnHistory.id == tryon_id).first()
            if not db_tryon:
                return
                
            # 1. Update status to 'processing'
            db_tryon.status = "processing"
            db.commit()
            
            # 2. Simulate AI execution delay (e.g. 5 seconds)
            time.sleep(5)
            
            # 3. Simulate image processing outputs
            # Standard output unique name
            filename = os.path.basename(uploaded_image)
            name, ext = os.path.splitext(filename)
            result_filename = f"result_{name}{ext}"
            
            # Ensure generated output path on disk exists (we mock it by copying the input upload file)
            src_path = os.path.join(settings.UPLOAD_DIR, filename)
            dest_path = os.path.join(settings.UPLOAD_DIR, result_filename)
            
            if os.path.exists(src_path):
                # Copy the original image as a mock AI overlay result
                shutil.copy(src_path, dest_path)
                db_tryon.generated_image = f"/uploads/{result_filename}"
                db_tryon.status = "completed"
            else:
                db_tryon.status = "failed"
                
            db.commit()
        except Exception as e:
            # Handle standard background errors cleanly
            try:
                db_tryon = db.query(TryOnHistory).filter(TryOnHistory.id == tryon_id).first()
                if db_tryon:
                    db_tryon.status = "failed"
                    db.commit()
            except:
                pass
        finally:
            db.close()
