#include "fs.h"
#include "lib/log.h"
#include "lib/zip.h"

#ifdef WIN32
#include <io.h>
#define F_OK 0
#define access _access
#endif

#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

typedef struct {
    int type;
    void *data;
} fs_mount_t;

fs_mount_t mount;

static int is_directory(const char *path) {
   struct stat statbuf;
   if (stat(path, &statbuf) != 0)
       return 0;
   return S_ISDIR(statbuf.st_mode);
}

int fs_init(const char *path) {
    if (!path) {
        path = getcwd(NULL, 0);
        if (access("data.bin", F_OK) == 0)
            path = "data.bin";
    }

    log_info("Attempting to mount %s", path);

    if (is_directory(path)) {
        mount = (fs_mount_t) {
            .type = FS_MOUNT_TYPE_FOLDER,
            .data = path
        };
        chdir(path);
        log_info("Mounted as folder.");
        return 0;
    }

    struct zip_t *zip = zip_open(path, 0, 'r');
    if (!zip)
        return 1;

    mount = (fs_mount_t) {
        .type = FS_MOUNT_TYPE_ZIP,
        .data = zip
    };
    log_info("Mounted as Zip.");

    return 0;
}

fs_file fs_read(const char *path) {
    fs_file file = FS_FILE_CLEAR;

    switch (mount.type) {
        case FS_MOUNT_TYPE_FOLDER: {
            FILE *raw_file = fopen(path, "r");
            if (!raw_file)
                return FS_FILE_CLEAR;
            
            fseek(raw_file, 0, SEEK_END);
            int size = ftell(raw_file);
            fseek(raw_file, 0, SEEK_SET); 

            file.size = size;

            char *buffer = malloc(size);
            fgets(&buffer, size, raw_file);
            fclose(raw_file);

            file.data = buffer;

            break;
        }

        case FS_MOUNT_TYPE_ZIP: {
            void *buf = NULL;
            size_t bufsize;

            {
                if (zip_entry_open(mount.data, path))
                    return FS_FILE_CLEAR;

                if (zip_entry_read(mount.data, &file.data, &file.size) < 0) 
                    return FS_FILE_CLEAR;
                
                if (zip_entry_close(mount.data))
                    return FS_FILE_CLEAR;
            }

            break;
        }
    }

    return file;
}

int fs_write(const char *path, const char *data) {
    
};
