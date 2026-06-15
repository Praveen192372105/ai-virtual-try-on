# backend/app/ai/pose_detector.py
"""Pose detector abstract interface and mock implementation.
Detects body pose landmarks from a human mask.
"""

from abc import ABC, abstractmethod
from typing import Any


class PoseDetector(ABC):
    @abstractmethod
    def detect(self, human_mask: Any) -> Any:
        """Detect pose landmarks from a human mask."""
        pass


class MockPoseDetector(PoseDetector):
    def detect(self, human_mask: Any) -> dict:
        # Return dummy pose landmarks
        return {"pose": "mock_pose_data", "mask": human_mask}
