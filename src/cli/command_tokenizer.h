#pragma once

#include <string>
#include <string_view>
#include <vector>

class ITokenizer {
public:
    virtual ~ITokenizer() = default;

    virtual std::vector<std::string> tokenize(
        std::string_view command,
        std::string_view separators = " \t"
    ) const = 0;
};

class BoostTokenizer : public ITokenizer {
public:
    std::vector<std::string> tokenize(
        std::string_view command,
        std::string_view separators = " \t"
    ) const override;
};