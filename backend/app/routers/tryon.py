from fastapi import APIRouter, Depends, HTTPException, Query, BackgroundTasks, status
from sqlalchemy.orm import Session
from typing import List

from app.database import get_db
from app.schemas.tryon import TryOnRequest, TryOnResponse
from app.services.tryon_service import TryOnService
from app.routers.deps import get_current_user
from app.models.user import User
from app.services.product_service import ProductService

router = APIRouter(prefix="/tryon", tags=["Try-On"])

@router.post("/start", response_model=TryOnResponse, status_code=status.HTTP_201_CREATED)
def start_tryon(
    request: TryOnRequest,
    background_tasks: BackgroundTasks,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)  # Protected by JWT
):
    # Verify the product exists first
    product = ProductService.get_product(db, product_id=request.product_id)
    if not product:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Product with ID {request.product_id} not found"
        )
        
    # Start background execution
    return TryOnService.start_tryon_process(
        db=db,
        user_id=current_user.id,
        product_id=request.product_id,
        uploaded_image=request.uploaded_image,
        background_tasks=background_tasks
    )

@router.get("/history", response_model=List[TryOnResponse])
def read_tryon_history(
    skip: int = Query(0, ge=0),
    limit: int = Query(50, ge=1, le=100),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)  # Protected by JWT
):
    return TryOnService.get_user_history(db, user_id=current_user.id, skip=skip, limit=limit)

@router.get("/{tryon_id}", response_model=TryOnResponse)
def read_tryon_detail(
    tryon_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)  # Protected by JWT
):
    tryon = TryOnService.get_tryon_by_id(db, tryon_id=tryon_id, user_id=current_user.id)
    if not tryon:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Try-on record not found or access denied"
        )
    return tryon
