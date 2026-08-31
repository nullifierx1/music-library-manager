#include <cli/command_tokenizer.h>

#include <boost/tokenizer.hpp>

std::vector<std::string> BoostTokenizer::tokenize(
    std::string_view command,
    std::string_view separators
) const {
    const std::string command_text{command};
    const std::string separator_text{separators};
    
    const boost::char_separator<char> separator{
        separator_text.c_str()
    };
    const boost::tokenizer<boost::char_separator<char>>
        tokens{command_text, separator};

    return {tokens.begin(), tokens.end()};
}