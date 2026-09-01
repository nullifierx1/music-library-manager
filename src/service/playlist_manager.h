#pragma once

#include <string>

#include <core/media_bundle.h>
#include <core/playlist.h>

namespace mlm {

class PlaylistManager {
public: 
    PlaylistManager(MediaBundle::playlists_t& pls)
        : playlists_reference_(pls) {}

private:
    MediaBundle::playlists_t& playlists_reference_;
};
    
} // namespace mlm