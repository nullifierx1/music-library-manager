#include <cli/command_tokenizer.h>

#include <boost/tokenizer.hpp>
#include <iostream>
#include <memory>

int main(void) {
    std::unique_ptr<ITokenizer> tok = std::make_unique<BoostTokenizer>();
    std::string command = "parse this command pls";
    
    for (const auto& token: tok->tokenize(command)) {
        std::cout << token << " ";
    }

    std::cout << std::endl;
}