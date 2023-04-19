/***************************************************************/
/*                                                             */
/*                   RISCV-LC System                           */
/*                                                             */
/*                     CEG3420 Lab3                            */
/*                 cbai@cse.cuhk.edu.hk                        */
/*           The Chinese University of Hong Kong               */
/*                                                             */
/***************************************************************/

#ifndef __FUNCTION_BLOCK_H__
#define __FUNCTION_BLOCK_H__

#include "util.h"

unsigned int mask_val(int, int, int);
int sext_unit(int, int);
int rs2_mux(int, int, int);
int mar_mux(int, int, int);
int alu(int, int, int, int);
int addr2_mux(int, int, int, int, int);
int addr1_mux(int, int, int, int, int);
int logic_shift_20_function_unit(int);
int shift_function_unit(int, int, int, int);
int pc_mux(int, int, int);
int s_format_imm_gen_unit(int, int);
int b_format_imm_gen_unit(int, int, int, int);
int j_format_imm_gen_unit(int, int, int, int);
int mdr_mux(int, int, int);
int rs1_en(int, int);
int rs2_en(int, int);
int alu_shift_mux(int, int, int);
int blockBMUX(int, int, int);
int compare_function_unit(int, int, int, int);
int datasize_mux(unsigned int, int, int);

#endif
