#include <service/library_manager.h>
#include <core/track.h>

#include <string>
#include <memory>
#include <cstddef>
#include <vector>

namespace mlm {

void LibraryManager::addTrack(const std::string& name /* other args like author etc */) {
    std::size_t idx = lib_reference_.data().size();

    if (lib_reference_.nameIdx().contains(name)) {
        lib_reference_.nameIdx()[name].emplace_back(idx);
    } else {
        std::vector<std::size_t> v{idx};
        lib_reference_.nameIdx().emplace(name, std::move(v));
    }

    auto track_ptr = std::make_shared<Track>(name);
    lib_reference_.data().emplace_back(track_ptr);
}

std::optional<std::size_t> LibraryManager::getTrackIndex(const std::string& name) const {
    if (!lib_reference_.nameIdx().contains(name)) {
        return std::nullopt;
    }

    const auto& matches = lib_reference_.nameIdx()[name];
    if (matches.size() == 1) {
        return matches[0];
    } else {
        for (const auto& idx : matches) {
            if (lib_reference_.data()[idx]->name() == name) 
                return idx;
        }
    }

    return std::nullopt;
}

std::shared_ptr<Track> LibraryManager::getTrack(const std::string& name) {
    auto optional_idx = getTrackIndex(name); 

    if (!optional_idx.has_value()) {
        return nullptr;
    } 

    return lib_reference_.data()[optional_idx.value()];
}

bool LibraryManager::updateTrack(const std::string& name /* args that's you update */) {
    auto optional_idx = getTrackIndex(name); 

    if (!optional_idx.has_value()) {
        return false;
    } 

    // TO DO
}

bool LibraryManager::deleteTrack(const std::string& name) {
    auto& data = lib_reference_.data();
    auto optional_idx = getTrackIndex(name); 

    if (!optional_idx.has_value()) {
        return false;
    } 

    data.erase(data.begin() + optional_idx.value());
}

std::size_t LibraryManager::trackCount() const {
    return lib_reference_.data().size();
}

} // namespace mlm