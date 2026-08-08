#pragma once

#include <boost/filesystem/path.hpp>
#include <chrono>
#include <cstddef>
#include <cstdint>
#include <string>

class Track {
public:
	struct TrackMeta {
		using year_t = std::uint16_t;

		std::string title;
		std::string artist;
		std::string genre;
		std::string album;
		year_t year = 0;
		std::chrono::seconds duration;
	};

private:
	boost::filesystem::path path_;
	std::size_t id_;
	TrackMeta track_meta_;
};