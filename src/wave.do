onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /Processor/pcInstance/PC
add wave -noupdate /Processor/clock
add wave -noupdate /Processor/pcInstance/syncPC
add wave -noupdate /Processor/instructionCacheInstance/instruction
add wave -noupdate /Processor/controllerInstance/unconditionalBranch
add wave -noupdate /Processor/controllerInstance/branch
add wave -noupdate /Processor/controllerInstance/memRead
add wave -noupdate /Processor/controllerInstance/memToReg
add wave -noupdate /Processor/controllerInstance/aluControlCode
add wave -noupdate /Processor/controllerInstance/memWrite
add wave -noupdate /Processor/controllerInstance/aluSRC
add wave -noupdate /Processor/controllerInstance/regWriteFlag
add wave -noupdate /Processor/controllerInstance/readRegister1
add wave -noupdate /Processor/controllerInstance/readRegister2
add wave -noupdate /Processor/controllerInstance/writeRegister
add wave -noupdate /Processor/operationPrepInstance/readData1
add wave -noupdate /Processor/operationPrepInstance/readData2
add wave -noupdate /Processor/operationPrepInstance/writeData
add wave -noupdate /Processor/controllerInstance/reg2Loc
add wave -noupdate /Processor/controllerInstance/opType
add wave -noupdate /Processor/controllerInstance/aluOP
add wave -noupdate /Processor/aluInstance/inOne
add wave -noupdate /Processor/aluInstance/inTwo
add wave -noupdate /Processor/aluInstance/opcode
add wave -noupdate /Processor/aluInstance/result
add wave -noupdate /Processor/aluInstance/zeroFlag
add wave -noupdate /Processor/aluInstance/carryBit
add wave -noupdate /Processor/dataCacheInstance/writeData
add wave -noupdate /Processor/dataCacheInstance/readData
add wave -noupdate /Processor/operationPrepInstance/reg1
add wave -noupdate /Processor/operationPrepInstance/reg2
add wave -noupdate /Processor/operationPrepInstance/writeRegister
add wave -noupdate -expand /Processor/operationPrepInstance/register
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {9 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 275
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {1 ns} {16 ns}
