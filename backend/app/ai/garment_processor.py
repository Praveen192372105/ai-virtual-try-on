# backend/app/ai/garment_processor.py
"""Garment processor abstract interface and mock implementation.
Applies garment image onto a pose.
"""

from abc import ABC, abstractmethod
from typing import Any


class GarmentProcessor(ABC):
    @abstractmethod
    def process(self, garment_image_path: str, pose_data: Any) -> Any:
        """Process garment with pose data and return a composite representation."""
        pass


class MockGarmentProcessor(GarmentProcessor):
    def process(self, garment_image_path: str, pose_data: Any) -> dict:
        # Return dummy composite data
        return {
            "garment_image": garment_image_path,
            "pose": pose_data,
            "composite": "mock_composite_data",
        }
