from abc import ABC, abstractmethod

class FileListReader(ABC):
    @abstractmethod
    def get_file_list(self) -> list[str]:
        pass
