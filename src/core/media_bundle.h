#pragma once

#include <core/library.h>
#include <core/playlist.h>

#include <vector>

namespace mlm {

class MediaBundle {
public:
    using playlists_t = std::vector<mlm::Playlist>;

    playlists_t& playlists() {
        return playlists_;
    }

    const playlists_t& playlists() const {
        return playlists_;
    }
    
    mlm::Library& library() {
        return library_;
    }

    const mlm::Library& library() const {
        return library_;
    }

private:
    playlists_t playlists_;
    mlm::Library library_;
};

} // namespace mlm