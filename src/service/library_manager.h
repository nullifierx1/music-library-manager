#pragma once

#include <core/library.h>

#include <string>
#include <cstddef>

namespace mlm {

class LibraryManager {
public:
    LibraryManager(mlm::Library& lib) 
        : lib_reference_(lib) {}

    /* Add track */
    void addTrack(const std::string& name /* other args */);

    /* Update track by name */
    void updateTrack(const std::string& name);

    /* Delete track by name */
    void deleteTrack(const std::string& name);

    /* Get track reference by name */
    std::shared_ptr<mlm::Track> getTrack(const std::string& name);

    /* Return track count */
    std::size_t trackCount() const;
    
private:
    mlm::Library& lib_reference_;
};

} // namespace mlm