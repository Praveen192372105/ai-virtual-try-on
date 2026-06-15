from pydantic_settings import BaseSettings
from typing import List

class Settings(BaseSettings):
    PROJECT_NAME: str = "AI Virtual Try-On API"
    API_V1_STR: str = "/api/v1"
    
    # CORS Configuration
    BACKEND_CORS_ORIGINS: List[str] = ["*"]  # In production, specify actual origins like http://localhost:5000
    
    # SQLite Database Config
    DATABASE_URL: str = "sqlite:///./tryon.db"
    
    # Upload Settings
    UPLOAD_DIR: str = "uploads"

    # Security & Auth Settings
    SECRET_KEY: str = "supersecret_default_key_for_development_purposes_12345"
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60 * 24 * 7  # 1 week

    class Config:
        case_sensitive = True
        env_file = ".env"

settings = Settings()
