
var bag
var current_version = 0
var migrations
var file_handler = File.new()
var version_file_path = "user://version.tof"

func init_bag(bag):
    self.bag = bag
    self.migrations = [
        preload("res://scripts/migrations/version20150730.gd").new(self.bag)
    ]
    self.load_version()
    self.run_migrations()
    self.save_version()

func load_version():
    if not self.file_handler.file_exists(self.version_file_path):
        return

    self.file_handler.open(self.version_file_path, File.READ)
    self.current_version = self.file_handler.get_var()
    self.file_handler.close()

func save_version():
    self.file_handler.open(self.version_file_path, File.WRITE)
    self.file_handler.store_var(self.current_version)
    self.file_handler.close()

func run_migrations():
    for migration in self.migrations:
        if migration.version > self.current_version:
            migration.migrate()
            self.current_version = migration.version