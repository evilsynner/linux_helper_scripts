from .file_list_reader import FileListReader
from pathlib import Path
from json import load as json_load

class JSONFileListReader(FileListReader):
    def __init__(self, file: Path):
        self._file = file
        super().__init__()

    def get_file_list(self) -> list[str]:
        with self._file.open("r", encoding="utf-8") as file:
            data = json_load(file)
            breakpoint()
