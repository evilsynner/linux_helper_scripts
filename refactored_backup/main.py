from pathlib import Path
from file_list_readers.json_file_list_reader import JSONFileListReader

class App:
    def start(self):
        file_list_path = Path("filelist.json")
        file_reader = JSONFileListReader(file=file_list_path)
        files_list = file_reader.get_file_list()


if __name__ == "__main__":
    app: App = App()
    app.start()
