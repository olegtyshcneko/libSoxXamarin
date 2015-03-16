//
//  soxxamarinbindings.c
//  XamarinSoxBindings
//
//  Created by Oleg Tyshchenko on 3/14/15.
//  Copyright (c) 2015 Oleg Tyshchenko. All rights reserved.
//

#include "soxxamarinbindings.h"

char *float_to_str_helper(float factor) {
    char* str;
    sprintf(str, "%1.1f", factor);
    return str;
}

void reduce_noise(char *inputPath, char *outputPath, char *noiseProfilePath, char* reductionFactor) {
    static sox_format_t *in, *out; /* input and output files */
    sox_effects_chain_t * e_chain;
    sox_effect_t * e;
    sox_effect_t * noise_e;
    char *args[10];
    
    //init sox and files:
    assert(sox_init() == SOX_SUCCESS);
    assert(in = sox_open_read(inputPath, NULL, NULL, NULL));
    assert(out = sox_open_write(outputPath, &in->signal, NULL, NULL, NULL, NULL));

    //create effect chain:
    e_chain = sox_create_effects_chain(&in->encoding, &out->encoding);
//
    //create and init input effect:
    e = sox_create_effect(sox_find_effect("input"));
    args[0] = (char *)in, assert(sox_effect_options(e, 1, args) == SOX_SUCCESS);
    assert(sox_add_effect(e_chain, e, &in->signal, &in->signal) == SOX_SUCCESS);

//    //create, init and add noisered effect:
    noise_e = sox_create_effect(sox_find_effect("noisered"));
    args[0] = noiseProfilePath;
    args[1] = reductionFactor;
    assert(sox_effect_options(noise_e, 2, args) == SOX_SUCCESS);
    assert(sox_add_effect(e_chain, noise_e, &in->signal, &in->signal) == SOX_SUCCESS);

    //create, init and add output effect:
    e = sox_create_effect(sox_find_effect("output"));
    args[0] = (char *)out, assert(sox_effect_options(e, 1, args) == SOX_SUCCESS);
    assert(sox_add_effect(e_chain, e, &in->signal, &in->signal) == SOX_SUCCESS);
//
//    //apply effects:
    sox_flow_effects(e_chain, NULL, NULL);
//
//    //clean up:
    sox_delete_effects_chain(e_chain);
    sox_close(out);
    sox_close(in);
    sox_quit();
}