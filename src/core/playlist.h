#pragma once

#include <core/track.h>

#include <vector>
#include <memory>

namespace mlm {

class Playlist {
public:
	// TO DO
	
private:
	std::vector<std::weak_ptr<Track>> data_;
};

} // namespace mlm