%%%% function to generate the DS FH signal
%%% SysParameter: system parameters
%%% Fd: doppler freq.
%%% SigLen: length of the signal to be generated

function [Sig] = DSFH(SysParameter,Fd,SigLen,DsCode_input,FhFreq_index,t_index)

%%% 0. generate rand info bits
NumBits = SigLen/SysParameter.FsTb;
Bit = sign(randi(2,1,NumBits)-1.5);   %%% uipolar to bipolar

%%% 1. generate the code sequence
Num_DsCode = NumBits/SysParameter.FbTcp;
DsCode = repmat(DsCode_input,1,Num_DsCode);

%%% 2. generate the FH frequency
FhFreq_min = SysParameter.Fo - SysParameter.FhFreq_inteval/2*(SysParameter.NumFhFreq-1);
%%% number of info Bit during each time period of hopping code
FhFreq = repmat(FhFreq_min + FhFreq_index*SysParameter.FhFreq_inteval,1,...
       Num_DsCode/SysParameter.FcpThp);

%%% 3. Spread the bits by DsCode
DSSS = DsCode.*rectpulse(Bit,SysParameter.FcTb);                              

%%% 4. Get the Sampled the DSSS code which code rate is affected by Dopppler
DSSS_sample =  code_rate_shift_sample(SysParameter,Fd,DSSS,t_index);


%%% 5. Freq hop the signal
t = 0+t_index:SysParameter.Ts:(length(DSSS_sample)-1)*(SysParameter.Ts)+t_index;
FhFreq_sample = hop_rate_shift_sample(SysParameter,Fd,rectpulse(FhFreq,SysParameter.FcTh),t_index);
Sig = DSSS_sample.*cos(2*pi*(FhFreq_sample+Fd).*t);

end