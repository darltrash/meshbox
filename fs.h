typedef struct {
    void *data;
    unsigned int size;
} fs_file;

#define FS_FILE_CLEAR (fs_file){ .data = NULL, .size = 0 }

enum {
    FS_MOUNT_TYPE_FOLDER = 1,
    FS_MOUNT_TYPE_ZIP    = 2
};

int fs_init(const char *path);

fs_file fs_read(const char *path);
int fs_write(const char *path, const char *data);