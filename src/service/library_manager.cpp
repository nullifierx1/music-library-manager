#include <service/library_manager.h>
#include <core/track.h>

#include <string>
#include <memory>
#include <cstddef>

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

std::shared_ptr<Track> LibraryManager::getTrack(const std::string& name) {
    if (!lib_reference_.nameIdx().contains(name)) {
        return nullptr;
    }

    auto matches = lib_reference_.nameIdx()[name];
    if (matches.size() == 1) {
        return lib_reference_.data()[matches[0]];
    } else {
        for (std::size_t i = 0; i < matches.size(); ++i) {
            if (lib_reference_.data()[i]->name() == name) 
                return lib_reference_.data()[i];
        }
    }

    return nullptr;
}



} // namespace mlm