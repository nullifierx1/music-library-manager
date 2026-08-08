#pragma once

#include <string>
#include <string_view>
#include <vector>

class ITokenizer {
public:
    virtual ~ITokenizer() = default;

    virtual std::vector<std::string> tokenize(
        const std::string& command
    ) const;
};

class BoostTokenizer : public ITokenizer {
public:
    std::vector<std::string> tokenize(
        const std::string& command
    ) const;

private:
    // TO DO
};