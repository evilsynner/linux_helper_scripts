from dataclasses import dataclass

@dataclass
class BackupConfig:
    backup_folder: str
    backup_files: list[str]
