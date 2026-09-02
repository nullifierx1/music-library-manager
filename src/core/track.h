#pragma once

#include <boost/filesystem/path.hpp>
#include <chrono>
#include <cstddef>
#include <cstdint>
#include <string>
#include <optional>

namespace mlm {

class Track {
public:
	struct TrackMeta {
		std::optional<std::string> artist;
		std::optional<std::string> genre;
		std::optional<std::string> album;
		std::optional<int> year = 0;
	};

	Track(std::string name /* other args */) 
		: name_(std::move(name)) {}

	const std::string& name() const {
		return name_;
	}

private:
	std::string name_;
	std::chrono::seconds duration_;
	boost::filesystem::path path_;
	TrackMeta track_meta_;
};

} // namespace mlm