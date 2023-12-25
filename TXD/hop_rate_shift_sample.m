%%% function to output Fh sample which code rate is affected by Dopppler
function [rate_shift_sample] = hop_rate_shift_sample(SysParameter,fd,FhFreq,t_index)
code_exp = [FhFreq(length(FhFreq)-3*SysParameter.Nc+1:end),FhFreq,FhFreq(1:3*SysParameter.Nc)];
N = length(FhFreq)*SysParameter.FsTc;                                      %number of sample
rate_shift = SysParameter.Fc + fd/(SysParameter.Fca/SysParameter.Fc);      %%chip rate after Fd
T_rate_shift = 1/rate_shift;                                               %time width of chip after chip rate shift
rate_shift_sample = code_exp(3*SysParameter.Nc + ...
    floor((SysParameter.Ts*(0:N-1)+fd/(SysParameter.Fca/SysParameter.Fc)*t_index*T_rate_shift)/T_rate_shift)+1);    