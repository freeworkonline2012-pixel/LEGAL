import {
  candidateId,
  formatClauseOutcome,
  formatContractShape,
  formatRetrievalStage,
  idList,
  lawCounts,
  textShape,
} from './retrieval-diagnostic';

const c = (lawNo: number, lawYear: number, articleNo: number) => ({ lawNo, lawYear, articleNo });

describe('retrieval-diagnostic (round 73)', () => {
  it('candidateId and lists are public identifiers only', () => {
    expect(candidateId(c(131, 1948, 646))).toBe('131/1948#646');
    expect(idList([c(131, 1948, 646), c(131, 1948, 646), c(17, 1983, 82)])).toBe('131/1948#646,17/1983#82');
    expect(idList([])).toBe('-');
    expect(lawCounts([c(131, 1948, 1), c(131, 1948, 2), c(181, 2018, 3)])).toBe('131/1948x2,181/2018x1');
  });

  it('textShape counts without exposing content', () => {
    const s = textShape('عقد أتعاب 5000 جنيه\nabc');
    expect(s.digits).toBe(4);
    expect(s.latinLetters).toBe(3);
    expect(s.lines).toBe(2);
    expect(s.arabicRatio).toBeGreaterThan(0.4);
    expect(textShape('').arabicRatio).toBe(0);
  });

  it('retrieval stage line carries counts and never the clause text', () => {
    const secret = 'سرى-جدا-نص-العقد';
    const line = formatRetrievalStage({
      clauseIndex: 2,
      shape: textShape(secret),
      criteria: 'fees',
      family: 'services',
      ftsTokens: 8,
      fts: [c(17, 1983, 82)],
      semConfigured: true,
      sem: [c(131, 1948, 699), c(176, 2018, 65)],
      merged: [c(17, 1983, 82), c(131, 1948, 699), c(176, 2018, 65)],
      afterFamily: [c(17, 1983, 82), c(131, 1948, 699), c(176, 2018, 65)],
      afterLawScope: [c(17, 1983, 82), c(131, 1948, 699)],
      anchorsRaw: [],
      anchorsKept: [],
    });
    expect(line).toContain('stage=retrieval clause=2');
    expect(line).toContain('fts=1 semConfigured=true sem=2 merged=3 droppedByFamily=0 droppedByLawScope=1 kept=2');
    expect(line).toContain('droppedLaws=176/2018x1');
    expect(line).not.toContain(secret);
  });

  it('outcome and contract lines', () => {
    expect(
      formatClauseOutcome({ clauseIndex: 1, outcome: 'empty_retrieval', reranked: null, topCandidates: 0, selected: 0, assessmentStatus: 'x', topIds: '-' }),
    ).toBe('[retrieval-diag] stage=outcome clause=1 outcome=empty_retrieval reranked=- topCandidates=0 selected=0 status=set topIds=-');
    const l = formatContractShape({ contractId: 'abc', extraction: textShape('كلمة'), clauseCount: 2, clauseChars: [300, 280], preambleChars: 0 });
    expect(l).toContain('clauses=2 preambleChars=0 clauseChars=[300,280]');
  });
});
