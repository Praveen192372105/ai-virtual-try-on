# backend/app/ai/virtual_tryon.py
"""Virtual try‑on pipeline abstract interface and mock implementation.
Combines human parsing, pose detection, and garment processing to generate a try‑on image URL.
"""

from abc import ABC, abstractmethod
from typing import Any


class VirtualTryOnEngine(ABC):
    @abstractmethod
    def run(self, user_image_path: str, garment_image_path: str) -> str:
        """Run the full try‑on pipeline and return a URL to the generated image."""
        pass


class MockVirtualTryOnEngine(VirtualTryOnEngine):
    def run(self, user_image_path: str, garment_image_path: str) -> str:
        # Return a placeholder image URL (could be a static asset or placeholder service)
        return "https://example.com/mock_generated_tryon.png"
