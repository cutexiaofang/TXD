%%% function  to output code sample which code rate is affected by Dopppler
function [rate_shift_sample] = code_rate_shift_sample(SysParameter,fd,code,t_index)
code_exp = [code(1:3*SysParameter.Nc),code,code(1:3*SysParameter.Nc)];
N = length(code)*SysParameter.FsTc;                                        %number of sample
rate_shift = SysParameter.Fc + fd/(SysParameter.Fca/SysParameter.Fc);      %chip rate after Fd
T_rate_shift = 1/rate_shift;                                               %time width of chip after chip rate shift
rate_shift_sample = code_exp(3*SysParameter.Nc + ...
    floor((SysParameter.Ts*(0:N-1)+fd/(SysParameter.Fca/SysParameter.Fc)*t_index*T_rate_shift)/T_rate_shift)+1);


